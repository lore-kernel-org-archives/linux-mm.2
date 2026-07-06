Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73278C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FA96B00D8; Mon,  6 Jul 2026 06:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F17C6B00DA; Mon,  6 Jul 2026 06:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090E66B00DB; Mon,  6 Jul 2026 06:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2DBC6B00D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:49:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C16E1203B1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:49:12 +0000 (UTC)
X-FDA: 84958029744.05.DB27850
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17244C0007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:49:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=M9NK3SZY;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d 9krHNl";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783334950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hbl5eISvgwpV0jt4t8mjCaNCsRooJAHxHYIcJLrEh2s=;
	b=aNFS26Ph4Tqv2l3LtYh7VmQZHOkmiMr0VYQz8mc1VU2bN/j2O5LDDmtqQwqlRQA0/cvK8V
	4X2CBZVFOdFp0bbmXcjW54yQQt3Jo6WZ4YkCkU/l+xLcioxgoykrW4wEgqyc241J2GWng3
	dCD7bDWXTtZCS4aPrap0PZBEGEe05E8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=M9NK3SZY;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d 9krHNl";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783334950;
	b=yrtX75TAdPQmbCACpOQP42CuRESwXlicmpjOaZ9bIMkoKCoa1T+JrzCBD8MV7GWLCe+x6E
	lEMWYqPeFUqWCMTwsQxVR4TeOYSB7Rup2y/VemMXeovMKsjGAc23tmCG1RZfT0VZosd/YJ
	f7J/lJVSxZMqYM04GwGfHT/AQmoFXn0=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D98F07A0122;
	Mon,  6 Jul 2026 06:49:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 06:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783334948; x=1783421348; bh=Hbl5eISvgwpV0jt4t8mjCaNCsRooJAHx
	HYIcJLrEh2s=; b=M9NK3SZYun/UU03iWbC7xPQFpp1K091Pprlgu/Ur7usCkgtl
	/jDSLhlNUa2LpWjfxz8m1uQT2T0GIGaCc8UmvdJuYI/qknlUcJqUdJjWJwM3BFXb
	d1iNBryouUaNtil2QX/sVMbJLmBgmgp9eNP36JI08vJwrvPM8Bt6M52oXHzKAkAx
	e9HqkGxjldfW5CeJ/ats5VN/XyJH04zlISPNo+dOssC9YWmjy2tXLkqTVrf18vhX
	oEhWp2l2cA8SxiQGcIqXpvy2B9N3VRofM7leZGZMKhIyjPrIyPm9N5D45DqvXkTh
	43PARxmtvSl2xfnqKT6XHQBsmVgrPDI5YlbbxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783334948; x=
	1783421348; bh=Hbl5eISvgwpV0jt4t8mjCaNCsRooJAHxHYIcJLrEh2s=; b=d
	9krHNlQds6qngEf8x48hef8siO1fjQo+XLkhJg8WKPutic7n/2ThRenyRFnijLl2
	kps2yzVccFr1ppEzrFXcr+d9P0e9EZHKMkDtvmOMAIFWMO4rbzEVQTyLqlrDM9Qr
	vY8tp1f5jpM4v7zFgy7cNbZKpfMfdCy4RjpXjHcpK2/3LLzsXXlqGYekiHc5gHkZ
	i6RFYc9SxL5zpqB6RfkN3ZG+Bz0A7neFqJuu+wo9NrroqRn0/wOWjUJ3fW9meLES
	XwSyh9zPrPM4emjXgISNY3CpJXFvU/zYhH9cQbenY77xat2pPSVml3SIicYwAo6z
	oQ2L8Qm1MAJCUT5fcZ6nA==
X-ME-Sender: <xms:JIhLaki3p4i-DGpJygPKPyW_j9EBC0RX10J3Uo487ph8uk-fCZ5GPA>
    <xme:JIhLag8BnhJczUP47RH9xCPNhLsy3dH1u7rBS6biqeHRPSLRzmmzv5n-feKcFUyr9
    NcXwfGI4G3DKYf8VA7xekwrkoYqf7NCZxjHiimF0r7ngsIwMpRem9o>
X-ME-Received: <xmr:JIhLakktyyatUaDoMDFkXuPjUl4-o1CfBSSIC9k8aDcWne33dQZ1MX5QKFFQmg>
X-ME-Proxy-Cause: dmFkZTFSejH1iEo/a+S/TxkIJz9eUtJXE95qhu6QD4qvfaAyF2oFVAg6ne91XWZmcXtcNS
    mk6x8XuG6bW97qEehAhIEF1MDo8aNIK+SZ8HfYURZi/2qNz0wyrJdUnMe8wTYwAJv/OYLm
    hfWViZrInpjHfpl032K2/XFmhRjF78aAdjYxiZn4MMvwEjdLiidl0HwSzW+4EbDAfN5ZDJ
    OqIlE3PXD9VaVGCq1mrVHVOBAtUKr1SUn2L0ID4fKwhMWTRT6+pAiaYx4G/Zi1DcIYNAtQ
    7bsV0bZnPb7btQoPA0AL7Ft063E6RAdKffIoAEEKuaokhRT+MrcLvJPcw1WP5ubbsKwBga
    IC/bguFK7znG4IT7bfAtOPSay1WkoQ4cbBevBn7PUfIqkyZ9BjbW2o6SJi8nM4127WteTd
    T9lwSpmowT1czKeix7b8sXBNoPXCzWJJthQq9tKmncYcSFlnwpg19l3DV0eY5lUk7p4plI
    kjbIziWRMwfIbfSv5KfPXAOb3mh1Hbs/b5O6Hn/5JIav2rtfFGv1IEWMVG4VLxh0VMPBZB
    9IwN1z5a/4lvhN+ftciVD/OyCCvYLxvAEO1BMCQDR+59mIC+ZulEVMlqRoQtYLyyDp3Wfo
    tL69eAN6G7ATu+eXGu/nY8EO0iAywTFW8bcVv+mtBkQEv6aFfGTsynmEt23Q
X-ME-Proxy: <xmx:JIhLau3uWY4VBNSmaA6j7EOE3HgaQPy0u6wCm8PrdXt5KM7zRrUD0w>
    <xmx:JIhLapT7NwCdEfuuE_mGMFI7LlMZhk-rTiDmhLWbkngzwSfGnhwbrQ>
    <xmx:JIhLauMnlqdDfVB_PcY0GJFiFpjck6P_TXYkAaP5qwob_qdZDVqcKA>
    <xmx:JIhLatgT-jH4uKfEymvSdTVQ3SEpwDHIiHV6PwUS0DxOxYBz7wuMiQ>
    <xmx:JIhLaijfir5IpBBP37hevpn-kcKqkF-Dfoi2z1JqDR0B_KUVDvymmJ4u>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 06:49:07 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v9.1 14/15] selftests/mm: add userfaultfd RWP tests
Date: Mon,  6 Jul 2026 11:49:06 +0100
Message-ID: <20260706104906.36084-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-15-kirill@shutemov.name>
References: <20260706084805.8400-15-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17244C0007
X-Stat-Signature: wmhzq3c15kyxsppmxjcp7hndyxwzybqh
X-HE-Tag: 1783334949-326862
X-HE-Meta: U2FsdGVkX195lyBoofmrFqUQZF3PAq06oUWpnza6kdxAmTjy7G0Srbj0C6lHFwiCNqcjoWpiMSLwl6IvxgbH/ikq08fm9G+vFIcgAxCVZScrrugdJMcvuCV75ng94im27aZ3C5BhFWm23Yca3DWu3bV2o66peummTHH/aoaTkrlOnS8IQ/BBk+GeaM/NA5PcUAvjZhrTn/X9uDojl1BJ81mNJ6q2qA4KprX3Z5lVpd/Ef5IsaCn3pgdfOCl7BSuIh4HhfHWgnlLv+CeftO9GlwruVDSgHTQzZEbEk9ns7wUBTDbSXwBGjBLaFL0ACH0aTYkkU1+nKxvYN6X7wZ+gpVkaXLEUWHjcYI3zJ42BCCwrb3S3tudQAWPrRR3QbMoEmKhMQuvlHoA3eHRN2Qby6/gf/WQiCWCwBvAj+OZWmNEX0lFB8RC19xASc6dDabb0osz6VBT2yFSQjfp/KlzQxSCCHLmy7gp2krLvpmDRhlW8/Sr4eoUJbnysTvbF++ghfVrc+XaI9p0ONynL4zDr26AyTLYaomIpPjkPd7TEx8Xr+29qPtKBadRsZV8Ygab5RQtKWgUdZofyZXPDaEIsd+6dJBIFgQW9GrckzWEXpYWDB+QbGbStwIHgb7Z+21KeWBzreG2HTd9NVtI8mTArUc87tP2JlwOkpi3p/Z+s2QtU0E28D+nlFL3g7kYH8uJsTtSWJx35Gz5A0bpXTEGAGqNaFSpIpU9lGLkPR0IaB22Xl1TZBjcp4s22DjSUo9rCIpa9WMD9M9ZYutHLGEk1nir+1DamuKsG6/UE/IfgeGV9Pqe589IrLmB0IF9G7D+FAiFSksATSw8x/ipzeENBjnbqR1l/5Iojgbq4+PYOOLDNc+1dvzm4vaJMcT6Y3GXb/Zwf5wbno4gInv+D2qmVajvVLqPZm9rzrPJCN695P/mFJ27gFPVqw67tAYrYPEgnqVpaj/6gOaiqNa99Th3
 6WwFc7JY
 D5XPKoThyWdRYLM2flrEbjekAB8YvwBFDfVKTKO70I90HYSuYryS3VNkIDvMTLYZCEmId5xf/DgcjCRd0eyotWFI67p43iRsQc/DbdgDq0QF1lkcOxzfVyQPHgJsvKfYqj/Pz1/nhbXAJRs9864Fa8qey7O5EzzAzbpjIdxMgzCyzU4l0Kr7s8tws4GAeG1GMW3cZ0w5lMVraaE7CASmbjZnt5qvc98TwJY6D2weOGU7vznKY6R+jh+HMiEQTrWCHIgfjQdnlGnBwGEU4VOHpd9sNppBChSfQ3zJ4zFNfy9gi5IppuhH2ck4QIuAK2xvCskXcrOs4ZKDGg/0ChGWaBEErOJvDi3DAMJW7BYIkNbNnuep+aAkxS60Yus8iZM65ltZQQoNBmK5SCbZ2ES/OeomDc+SF8aHYhtsSoRMlpQyS5UMuZ/X1eVxRI8TAPCPqT9JDxN2ShMY7GKA7tlajiS9Q2epWDyiLP9OHza9x4N74XjWuTzDVlzYvyDmVVRCoONKIFQe4r04xrFoIdZhucVNgOy9HUAaAVqqGfjUbMwAI0arvg99RvbLYqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Coverage for UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT:

  rwp-async          async mode — touch pages, verify permissions are
                     auto-restored without a message
  rwp-sync           sync mode — access blocks, handler resolves via
                     UFFDIO_RWPROTECT
  rwp-pagemap        PAGEMAP_SCAN reports still-cold pages via
                     inverted PAGE_IS_ACCESSED
  rwp-mprotect       RWP survives mprotect(PROT_NONE) ->
                     mprotect(PROT_READ|PROT_WRITE) round-trip
  rwp-gup            GUP walks through a protnone RWP PTE (pipe
                     write/read drives the GUP path)
  rwp-async-toggle   UFFDIO_SET_MODE flips between sync and async
                     without re-registering
  rwp-close          closing the uffd restores page permissions
  rwp-fork           RWP survives fork() with EVENT_FORK; child's
                     PTEs keep the uffd bit
  rwp-fork-pin       RWP survives fork() on an RO-longterm-pinned
                     anon page (forces copy_present_page()); child
                     read auto-resolves and clears the bit, proving
                     PAGE_NONE was in place
  rwp-wp-exclusive   register with MODE_WP|MODE_RWP returns -EINVAL

All tests run against anon, shmem, shmem-private, hugetlb, and
hugetlb-private memory, except rwp-fork-pin which is anon-only —
copy_present_page() is the private-anon pinned-exclusive fork path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

Single-patch update to 14/15 of the v9 RWP series [1], addressing the
Sashiko AI review of 14/15; only this patch changes. Sent in reply to
the original.

Changes since v9:
  - Tolerate EINVAL from madvise(MADV_NOHUGEPAGE) so the suite does not
    abort on CONFIG_TRANSPARENT_HUGEPAGE=n kernels.
  - rwp-mprotect and rwp-fork-pin now assert the marker survived (check
    PM_UFFD_WP) before the touch that would auto-resolve it, so a kernel
    that dropped the marker fails the test instead of passing vacuously.

[1] https://lore.kernel.org/all/20260706084805.8400-1-kirill@shutemov.name/
 tools/testing/selftests/mm/uffd-unit-tests.c | 919 +++++++++++++++++++
 1 file changed, 919 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index a6c14109e818..ef9b3956bdcf 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -7,6 +7,8 @@
 
 #include "uffd-common.h"
 
+#include <linux/fs.h>
+#include <sys/uio.h>
 #include "../../../../mm/gup_test.h"
 
 #ifdef __NR_userfaultfd
@@ -109,6 +111,10 @@ static void uffd_test_skip(const char *message)
 
 static void test_uffd_api(bool use_dev)
 {
+	const uint64_t expected_ioctls =
+		BIT_ULL(_UFFDIO_REGISTER) |
+		BIT_ULL(_UFFDIO_UNREGISTER) |
+		BIT_ULL(_UFFDIO_API);
 	struct uffdio_api uffdio_api;
 	int uffd;
 
@@ -148,6 +154,15 @@ static void test_uffd_api(bool use_dev)
 		goto out;
 	}
 
+	/* Verify returned fd-level ioctls bitmask */
+	if ((uffdio_api.ioctls & expected_ioctls) != expected_ioctls) {
+		uffd_test_fail("UFFDIO_API missing expected ioctls: "
+			       "got=0x%"PRIx64", expected=0x%"PRIx64,
+			       (uint64_t)uffdio_api.ioctls,
+			       expected_ioctls);
+		goto out;
+	}
+
 	/* Test double requests of UFFDIO_API with a random feature set */
 	uffdio_api.features = BIT_ULL(0);
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == 0) {
@@ -602,6 +617,814 @@ void uffd_minor_collapse_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *
 	uffd_minor_test_common(gopts, true, false);
 }
 
+static int uffd_register_rwp(int uffd, void *addr, uint64_t len)
+{
+	struct uffdio_register reg = {
+		.range = { .start = (unsigned long)addr, .len = len },
+		.mode = UFFDIO_REGISTER_MODE_RWP,
+	};
+
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg) == -1)
+		return -errno;
+	return 0;
+}
+
+static void rwprotect_range(int uffd, __u64 start, __u64 len, bool protect)
+{
+	struct uffdio_rwprotect rwp = {
+		.range = { .start = start, .len = len },
+		.mode = protect ? UFFDIO_RWPROTECT_MODE_RWP : 0,
+	};
+
+	if (ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
+		err("UFFDIO_RWPROTECT failed");
+}
+
+static void set_async_mode(int uffd, bool enable)
+{
+	struct uffdio_set_mode mode = { };
+
+	if (enable)
+		mode.enable = UFFD_FEATURE_RWP_ASYNC;
+	else
+		mode.disable = UFFD_FEATURE_RWP_ASYNC;
+
+	if (ioctl(uffd, UFFDIO_SET_MODE, &mode))
+		err("UFFDIO_SET_MODE failed");
+}
+
+/*
+ * Test async RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP with RWP_ASYNC,
+ * RW-protect, re-access, verify content preserved and no faults delivered.
+ */
+static void uffd_rwp_async_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate all pages with known content */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages (sets protnone) */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Access all pages — should auto-resolve, no faults */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu content mismatch: %u != %u",
+				       p, page[0], expected);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Fault handler for RWP — unprotect the page via UFFDIO_RWPROTECT.
+ */
+static void uffd_handle_rwp_fault(uffd_global_test_opts_t *gopts,
+				  struct uffd_msg *msg,
+				  struct uffd_args *uargs)
+{
+	if (!(msg->arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP))
+		err("expected RWP fault, got 0x%llx",
+		    msg->arg.pagefault.flags);
+
+	rwprotect_range(gopts->uffd, msg->arg.pagefault.address,
+			gopts->page_size, false);
+	uargs->minor_faults++;
+}
+
+/*
+ * Test sync RWP faults on anonymous memory.
+ * Populate pages, register MODE_RWP (sync), RW-protect,
+ * access from worker thread, verify fault delivered, UFFDIO_RWPROTECT resolves.
+ */
+static void uffd_rwp_sync_test(uffd_global_test_opts_t *gopts,
+				      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	pthread_t uffd_mon;
+	struct uffd_args uargs = { };
+	bool failed = false;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	/* Register MODE_RWP */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* RW-protect all pages */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Start fault handler thread */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access all pages — triggers sync RWP faults, handler unprotects */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			failed = true;
+			goto out;
+		}
+	}
+
+out:
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (failed)
+		return;
+	if (uargs.minor_faults == 0)
+		uffd_test_fail("expected RWP faults, got 0");
+	else
+		uffd_test_pass();
+}
+
+/*
+ * Test PAGEMAP_SCAN working-set discovery via the "hot" (accessed) scan.
+ *
+ * The working-set primitive is to find pages that were accessed: scan for
+ * PAGE_IS_ACCESSED, which is set once an access clears the protnone+uffd
+ * marker.  A VMM treats every access fault as "hot" (RWP here; MINOR/MISSING
+ * for non-resident pages) and reclaims the rest from the backing file.
+ *
+ * We deliberately do NOT use an inverted "cold" scan: that only sees
+ * VMA-resident ptes, so for a file mapping it misses cached-but-unmapped (and
+ * never-faulted, pre-populated) pages, which are pte_none and thus invisible.
+ * Hot tracking + file-level reclaim covers them; a cold pte scan cannot.
+ */
+static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
+					  uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	long ret;
+
+	/* Need at least 4 pages */
+	if (nr_pages < 4) {
+		uffd_test_skip("need at least 4 pages");
+		return;
+	}
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and RW-protect */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Touch first half of pages to re-activate them (async auto-resolve) */
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uint64_t start = (uint64_t)gopts->area_dst;
+	uint64_t boundary = start + (nr_pages / 2) * page_size;
+	uint64_t end = start + nr_pages * page_size;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	/*
+	 * Hot scan: report the pages that were accessed.  PAGE_IS_ACCESSED is
+	 * set once the protnone+uffd marker is cleared (by the access, async
+	 * auto-resolve here).  The touched first half must come back as exactly
+	 * one hot region [start, boundary); the untouched second half must not
+	 * appear.
+	 */
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = start;
+	pm_arg.end = end;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+
+	if (ret != 1 || regions[0].start != start ||
+	    regions[0].end != boundary) {
+		uffd_test_fail("hot set wrong: got %ld regions [0x%lx,0x%lx), expected 1 [0x%lx,0x%lx)",
+			       ret, (unsigned long)regions[0].start,
+			       (unsigned long)regions[0].end,
+			       (unsigned long)start, (unsigned long)boundary);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that RWP protection survives a mprotect(PROT_NONE) ->
+ * mprotect(PROT_READ|PROT_WRITE) round-trip. The uffd-wp bit on a
+ * VM_UFFD_RWP VMA must continue to carry PROT_NONE semantics after
+ * mprotect() changes the base protection; otherwise accesses would
+ * silently succeed and the pagemap bit would stick without a fault
+ * ever clearing it.
+ */
+static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+	struct page_region regions[16];
+	struct pm_scan_arg pm_arg;
+	int pagemap_fd;
+	uint64_t value;
+	long ret;
+
+	/* Populate all pages */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, 0xab, page_size);
+
+	/* Register and RW-protect the whole range */
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failure");
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			nr_pages * page_size, true);
+
+	/* Round-trip mprotect(): PROT_NONE -> PROT_READ|PROT_WRITE */
+	if (mprotect(gopts->area_dst, nr_pages * page_size, PROT_NONE))
+		err("mprotect() PROT_NONE");
+	if (mprotect(gopts->area_dst, nr_pages * page_size,
+		     PROT_READ | PROT_WRITE))
+		err("mprotect() PROT_READ|PROT_WRITE");
+
+	/*
+	 * The marker must survive the round-trip; if mprotect() dropped it,
+	 * the touches below would not fault and the scan would pass
+	 * vacuously.
+	 */
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	close(pagemap_fd);
+	if (!(value & PM_UFFD_WP)) {
+		uffd_test_fail("RWP marker lost across mprotect()");
+		return;
+	}
+
+	/* Touch every page. Async RWP must auto-resolve each fault. */
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	/*
+	 * After touching, no page should remain RW-protected. A stuck
+	 * uffd-wp bit would mean mprotect() silently dropped PROT_NONE and
+	 * the access never faulted.
+	 */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		err("open pagemap");
+
+	memset(&pm_arg, 0, sizeof(pm_arg));
+	pm_arg.size = sizeof(pm_arg);
+	pm_arg.start = (uint64_t)gopts->area_dst;
+	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
+	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec_len = ARRAY_SIZE(regions);
+	pm_arg.category_mask = PAGE_IS_ACCESSED;
+	pm_arg.category_inverted = PAGE_IS_ACCESSED;
+	pm_arg.return_mask = PAGE_IS_ACCESSED;
+
+	ret = ioctl(pagemap_fd, PAGEMAP_SCAN, &pm_arg);
+	close(pagemap_fd);
+
+	if (ret < 0) {
+		uffd_test_fail("PAGEMAP_SCAN failed: %s", strerror(errno));
+		return;
+	}
+	if (ret != 0) {
+		uffd_test_fail("expected no cold pages after mprotect()+touch, got %ld regions",
+			       ret);
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that GUP resolves through protnone PTEs (async mode).
+ * vmsplice() into a pipe pins user pages via get_user_pages_fast() --
+ * unlike write(), which goes through copy_from_user() and ordinary
+ * hardware page faults -- so it exercises gup_can_follow_protnone() on
+ * the RW-protected PTE. In async mode the kernel auto-restores
+ * permissions and GUP returns the page.
+ */
+static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
+				     uffd_test_args_t *args)
+{
+	struct iovec iov;
+	char buf;
+	int pipefd[2];
+
+	/* Populate first page with known content */
+	memset(gopts->area_dst, 0xCD, gopts->page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, gopts->page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			gopts->page_size, true);
+
+	if (pipe(pipefd))
+		err("pipe");
+
+	/*
+	 * One byte's worth of iov is enough to GUP the containing page and
+	 * keeps the pipe transfer well under any pipe-capacity limit even on
+	 * hugetlb-backed runs.
+	 */
+	iov.iov_base = gopts->area_dst;
+	iov.iov_len = 1;
+	if (vmsplice(pipefd[1], &iov, 1, 0) != 1) {
+		uffd_test_fail("vmsplice from RW-protected page failed: %s",
+			       strerror(errno));
+		goto out;
+	}
+
+	if (read(pipefd[0], &buf, 1) != 1) {
+		uffd_test_fail("read from pipe failed");
+		goto out;
+	}
+
+	if (buf != (char)0xCD) {
+		uffd_test_fail("content mismatch: got 0x%02x, expected 0xCD",
+			       (unsigned char)buf);
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
+/*
+ * Test runtime toggle between async and sync modes.
+ * Start in async mode (detection), flip to sync (eviction), verify faults
+ * block, resolve them, flip back to async.
+ */
+static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
+					      uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffd_args uargs = { };
+	pthread_t uffd_mon;
+	char c = '\0';
+	unsigned long p;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	/* Phase 1: async detection — RW-protect, access first half */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	for (p = 0; p < nr_pages / 2; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;  /* auto-resolves in async mode */
+	}
+
+	/* Phase 2: flip to sync for eviction */
+	set_async_mode(gopts->uffd, false);
+
+	/* Start handler — will receive faults for cold pages */
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/* Access second half (cold pages) — should trigger sync faults */
+	for (p = nr_pages / 2; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		if (page[0] != (p % 255 + 1)) {
+			uffd_test_fail("page %lu content mismatch", p);
+			goto out;
+		}
+	}
+
+	/*
+	 * Stop the handler before reading minor_faults: the last fault
+	 * resolution rwprotect_range()s before incrementing the counter,
+	 * so the main thread can race ahead of the increment. Stopping
+	 * here also makes Phase 3 a clean async-only test -- with the
+	 * handler still running it would silently resolve any sync fault
+	 * the kernel erroneously delivers, masking a regression.
+	 */
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (uargs.minor_faults == 0) {
+		uffd_test_fail("expected sync faults, got 0");
+		return;
+	}
+
+	/* Phase 3: flip back to async */
+	set_async_mode(gopts->uffd, true);
+
+	/* RW-protect and access again — should auto-resolve */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	for (p = 0; p < nr_pages; p++) {
+		volatile char *page = gopts->area_dst + p * page_size;
+		(void)*page;
+	}
+
+	uffd_test_pass();
+	return;
+out:
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+}
+
+/*
+ * Test that RW-protected pages become accessible after closing uffd.
+ */
+static void uffd_rwp_close_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	unsigned long p;
+
+	/* Populate */
+	for (p = 0; p < nr_pages; p++)
+		memset(gopts->area_dst + p * page_size, p % 255 + 1, page_size);
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			  nr_pages * page_size))
+		err("register failure");
+
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			 nr_pages * page_size, true);
+
+	/* Close uffd — should restore protnone PTEs */
+	close(gopts->uffd);
+	gopts->uffd = -1;
+
+	/* All pages should be accessible with original content */
+	for (p = 0; p < nr_pages; p++) {
+		unsigned char *page = (unsigned char *)gopts->area_dst +
+				      p * page_size;
+		unsigned char expected = p % 255 + 1;
+
+		if (page[0] != expected) {
+			uffd_test_fail("page %lu not accessible after close", p);
+			return;
+		}
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * Test that RWP protection is preserved across fork() when
+ * UFFD_FEATURE_EVENT_FORK is enabled. Without preservation, the child's
+ * PTEs would lose the uffd-wp marker and RWP-protected accesses would
+ * silently fall through to do_numa_page().
+ */
+static void uffd_rwp_fork_test(uffd_global_test_opts_t *gopts,
+			       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	int pagemap_fd;
+	uint64_t value;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
+			      nr_pages * page_size))
+		err("register failed");
+
+	/* Populate + RWP-protect */
+	*gopts->area_dst = 1;
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+			page_size, true);
+
+	/* Parent: verify uffd-wp bit is set before fork */
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * Fork with EVENT_FORK: child inherits VM_UFFD_RWP. Child reads
+	 * its own pagemap and must still see the uffd-wp bit set.
+	 */
+	if (pagemap_test_fork(gopts, true, false)) {
+		uffd_test_fail("RWP marker lost in child after fork");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pagemap_fd);
+}
+
+/*
+ * Test that RWP protection on a pinned anon page is preserved across fork().
+ * Pinning forces copy_present_page() in the child path, which must restore
+ * PAGE_NONE on top of the uffd bit. Using async mode, a read in the child
+ * auto-resolves if — and only if — the PTE was actually protnone+uffd; the
+ * cleared uffd bit afterward proves the fault path ran.
+ */
+static void uffd_rwp_fork_pin_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	fork_event_args fevent_args = { .gopts = gopts, .child_uffd = -1 };
+	pin_args pin_args = {};
+	int pagemap_fd, status;
+	pthread_t fevent_thread;
+	uint64_t value;
+	pid_t child;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
+		err("register failed");
+
+	/* Populate. */
+	*gopts->area_dst = 1;
+
+	/* RO-longterm pin so fork() takes copy_present_page() for this PTE. */
+	if (pin_pages(&pin_args, gopts->area_dst, page_size)) {
+		uffd_test_skip("Possibly CONFIG_GUP_TEST missing or unprivileged");
+		uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+		return;
+	}
+
+	/* RWP-protect: PTE is now PAGE_NONE + uffd bit. */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, true);
+
+	/*
+	 * UFFD_FEATURE_EVENT_FORK is required so the child inherits
+	 * VM_UFFD_RWP and the marker; without it dup_userfaultfd() resets
+	 * the child VMA and the test would pass for the wrong reason.
+	 * dup_userfaultfd() blocks until the EVENT_FORK message is consumed,
+	 * so spawn a reader before the fork().
+	 */
+	gopts->ready_for_fork = false;
+	if (pthread_create(&fevent_thread, NULL, fork_event_consumer,
+			   &fevent_args))
+		err("pthread_create() for fork event consumer");
+	while (!gopts->ready_for_fork)
+		; /* Wait for consumer to start polling. */
+
+	child = fork();
+	if (child < 0)
+		err("fork");
+	if (child == 0) {
+		volatile char c;
+		int cfd;
+
+		/*
+		 * Precondition: the child must have inherited the marker.
+		 * If copy_present_page() dropped it together with PAGE_NONE,
+		 * the read below would succeed without the fault path and
+		 * the after-read check would pass for the wrong reason.
+		 */
+		cfd = pagemap_open();
+		value = pagemap_get_entry(cfd, gopts->area_dst);
+		if (!(value & PM_UFFD_WP)) {
+			close(cfd);
+			_exit(2);
+		}
+
+		/*
+		 * Read the pinned page. Only reaches the fault path if the
+		 * child PTE is protnone + uffd; async mode auto-resolves and
+		 * clears the uffd bit. If copy_present_page() dropped
+		 * PAGE_NONE, the read would silently succeed and the bit
+		 * would still be set.
+		 */
+		c = *(volatile char *)gopts->area_dst;
+		(void)c;
+
+		value = pagemap_get_entry(cfd, gopts->area_dst);
+		close(cfd);
+		_exit((value & PM_UFFD_WP) ? 1 : 0);
+	}
+	if (waitpid(child, &status, 0) < 0)
+		err("waitpid");
+	if (pthread_join(fevent_thread, NULL))
+		err("pthread_join() for fork event consumer");
+	if (fevent_args.child_uffd >= 0)
+		close(fevent_args.child_uffd);
+
+	unpin_pages(&pin_args);
+	close(pagemap_fd);
+	if (uffd_unregister(gopts->uffd, gopts->area_dst, page_size))
+		err("unregister failed");
+
+	if (WIFEXITED(status) && WEXITSTATUS(status) == 2) {
+		uffd_test_fail("RWP marker not inherited by child");
+		return;
+	}
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		uffd_test_fail("RWP not enforced in child after pinned fork");
+		return;
+	}
+
+	uffd_test_pass();
+}
+
+/*
+ * A non-exclusive (forked, COW-shared) anon page that is RWP-protected and
+ * then swapped out must keep tracking across swap-in. On the write that
+ * swaps it back in, do_swap_page() restores PAGE_NONE and the access retries
+ * through the RWP fault path, instead of being COWed straight to a fresh
+ * accessible page -- which would silently drop the marker for a non-exclusive
+ * folio. Sync mode lets us observe the fault directly: with the bug, the
+ * write COWs without delivering any RWP fault.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_rwp_swap_cow_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *args)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffd_args uargs = { };
+	int pagemap_fd, go[2], i;
+	pthread_t uffd_mon;
+	char c = '\0';
+	pid_t child;
+
+	uargs.gopts = gopts;
+	uargs.handle_fault = uffd_handle_rwp_fault;
+
+	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, page_size))
+		err("register failed");
+
+	/* Populate one page (exclusive at this point). */
+	*gopts->area_dst = 0x11;
+
+	/* RWP-protect: PTE becomes PAGE_NONE + uffd bit (still exclusive). */
+	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+
+	/*
+	 * Swap the page out while it is still exclusive: a shared (forked)
+	 * folio does not get reclaimed by MADV_PAGEOUT. Retry, since a hot
+	 * page may just be rotated on the first reclaim pass.
+	 */
+	pagemap_fd = pagemap_open();
+	for (i = 0; i < 100; i++) {
+		if (madvise(gopts->area_dst, page_size, MADV_PAGEOUT))
+			err("MADV_PAGEOUT");
+		if (pagemap_is_swapped(pagemap_fd, gopts->area_dst))
+			break;
+		usleep(10000);
+	}
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_dst)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		close(pagemap_fd);
+		uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+		return;
+	}
+
+	/*
+	 * fork() now: the child duplicates the swap entry, so the slot becomes
+	 * non-exclusive. The child parks (keeping the reference) until the
+	 * parent has faulted the page back in.
+	 */
+	if (pipe(go))
+		err("pipe");
+	child = fork();
+	if (child < 0)
+		err("fork");
+	if (child == 0) {
+		close(go[1]);
+		read(go[0], &c, 1);
+		_exit(0);
+	}
+	close(go[0]);
+
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &uargs))
+		err("uffd_poll_thread create");
+
+	/*
+	 * Write the page: swaps it back in (do_swap_page) on a non-exclusive
+	 * folio with FAULT_FLAG_WRITE. The marker must survive and deliver an
+	 * RWP fault rather than COW silently.
+	 */
+	*gopts->area_dst = 0x22;
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join failed");
+
+	if (uargs.minor_faults == 0)
+		uffd_test_fail("no RWP fault on swapped-in non-exclusive page");
+	else
+		uffd_test_pass();
+
+	close(pagemap_fd);
+	if (write(go[1], &c, 1) != 1)
+		err("child release");
+	close(go[1]);
+	waitpid(child, NULL, 0);
+}
+
+/*
+ * WP and RWP share the uffd-wp PTE bit and cannot coexist in the same VMA.
+ * Registration requesting both modes must be rejected.
+ */
+static void uffd_rwp_wp_exclusive_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	unsigned long nr_pages = gopts->nr_pages;
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_register reg = { };
+
+	reg.range.start = (unsigned long)gopts->area_dst;
+	reg.range.len = nr_pages * page_size;
+	reg.mode = UFFDIO_REGISTER_MODE_WP | UFFDIO_REGISTER_MODE_RWP;
+
+	if (ioctl(gopts->uffd, UFFDIO_REGISTER, &reg) == 0) {
+		uffd_test_fail("register with WP|RWP unexpectedly succeeded");
+		return;
+	}
+	if (errno != EINVAL) {
+		uffd_test_fail("register with WP|RWP: expected EINVAL, got %d",
+			       errno);
+		return;
+	}
+	uffd_test_pass();
+}
+
 static sigjmp_buf jbuf, *sigbuf;
 
 static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
@@ -1604,6 +2427,83 @@ uffd_test_case_t uffd_tests[] = {
 		/* We can't test MADV_COLLAPSE, so try our luck */
 		.uffd_feature_required = UFFD_FEATURE_MINOR_SHMEM,
 	},
+	{
+		.name = "rwp-async",
+		.uffd_fn = uffd_rwp_async_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-sync",
+		.uffd_fn = uffd_rwp_sync_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-pagemap",
+		.uffd_fn = uffd_rwp_pagemap_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-mprotect",
+		.uffd_fn = uffd_rwp_mprotect_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-gup",
+		.uffd_fn = uffd_rwp_gup_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-async-toggle",
+		.uffd_fn = uffd_rwp_async_toggle_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
+	},
+	{
+		.name = "rwp-close",
+		.uffd_fn = uffd_rwp_close_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-fork",
+		.uffd_fn = uffd_rwp_fork_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-fork-pin",
+		.uffd_fn = uffd_rwp_fork_pin_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC |
+		UFFD_FEATURE_EVENT_FORK,
+	},
+	{
+		.name = "rwp-swap-cow",
+		.uffd_fn = uffd_rwp_swap_cow_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_RWP,
+	},
+	{
+		.name = "rwp-wp-exclusive",
+		.uffd_fn = uffd_rwp_wp_exclusive_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required =
+		UFFD_FEATURE_RWP |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
 	{
 		.name = "sigbus",
 		.uffd_fn = uffd_sigbus_test,
@@ -1814,6 +2714,25 @@ int main(int argc, char *argv[])
 				uffd_test_skip(errmsg);
 				continue;
 			}
+			/*
+			 * RWP tracks protection on ptes; a THP-backed shmem/anon
+			 * range (e.g. shmem_enabled=always) would split on
+			 * rwprotect and change behaviour under the test. Keep
+			 * such ranges off THP. hugetlb is huge by definition and
+			 * rejects MADV_NOHUGEPAGE, so skip it.
+			 */
+			if ((test->uffd_feature_required & UFFD_FEATURE_RWP) &&
+			    !(mem_type->mem_flag & (MEM_HUGETLB | MEM_HUGETLB_PRIVATE))) {
+				unsigned long len = gopts.nr_pages * gopts.page_size;
+
+				/*
+				 * EINVAL means CONFIG_TRANSPARENT_HUGEPAGE=n:
+				 * nothing to opt out of.
+				 */
+				if (madvise(gopts.area_dst, len, MADV_NOHUGEPAGE) &&
+				    errno != EINVAL)
+					err("madvise(MADV_NOHUGEPAGE)");
+			}
 			test->uffd_fn(&gopts, &args);
 			uffd_test_ctx_clear(&gopts);
 		}

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
prerequisite-patch-id: 501a63478277bcaf68e6cec58ac1f85db1a98783
prerequisite-patch-id: e265e2ac6bf42c0d365e6ba16ceadfb6d8fc0fb6
prerequisite-patch-id: dae4338f458e1913ea04b250c1d9fc43bf5acf88
prerequisite-patch-id: 15a31b32309ec5cd9a4f7a734ca8a30d66b7a4a1
prerequisite-patch-id: 7bcaf2b7c5942d630fee567a2f115396f70fd9c4
prerequisite-patch-id: 6c54fb9d88ae14f70b985f4a8c0ce3e07626bfd0
prerequisite-patch-id: 7b07d85bf84957c948cd93f8399575cd190d0759
prerequisite-patch-id: 3b1feecd7a20710751a691e060ce7dbdc33d9043
prerequisite-patch-id: 0deb0090f6372cd27933dec0188d1a91dd93848d
prerequisite-patch-id: 1707566c09781254c16017547a250229c57991fe
prerequisite-patch-id: e5b5c329ec1105aacc220f929814243aef203238
prerequisite-patch-id: e1f0fd725c79e0460099a131a60481248006a877
prerequisite-patch-id: 4a57fd062eb152322a265fae5346386a6a8fec78
-- 
2.54.0


