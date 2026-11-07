Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6201E606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liQDf2ND
Received: by kanga.kvack.org (Postfix)
	id 31AE96B05E6; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2EB6B05E8; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D486B05E9; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8DC06B05E8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 799CD1A026B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
X-FDA: 85406458872.28.FC8AE3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6288E120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=liQDf2ND;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZM6CRwABi3fstnzX44ArAuSrBU3GRfAEQ1WggcvHU4=;
	b=PC2sZjVqjk3Tuc34sTgOe+wa2ne9EHwXxqPeJLfQf8OcaLYtc+tl5/cW0QQdmKeZMrjAKe
	wGz13wto3Kp+V/d2+lDU08eGUrDkp8pofHYurGMmop0HeFlKxT4e4l7XfDW/zh89tRqzeY
	MxJkQLhD3QRGVkDeqU/Lw0J4dDrVzBE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011834;
	b=A2cyU/JGmLJCtt4+aFdSw9R1YZm4ooHPq5BQLIU7zL2qX1R4a9VN3weDeJenS4bXUdAKh4
	h4T1w0DtPGpUkK6O1d/oFVncITLqvooHBoB7qaJRdBnsqV4/ec8BWzVUUiqVAAc9zB8xg+
	8dyf0p+WzIUbWz0TUdaRFsntKpoFkTo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=liQDf2ND;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36C9743AE3;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011834;
	b=yvD+sBaPrBpS/CBFoMPYG6zV6MJCfpbb00j/t8JZtcs1A8/pjD9jCpL2IoiDexxsYp5T
	 5eWBqjMKTp6PU+xVEF9VqoWMz8CyBBTaEbZdakL23VvxZZ3IW2ROKQvPrpd+dAFUbqd8w
	 lPH2WqEfoIobPGjMRPXluPeAEZ3XeJATVUB8lJYUidcVZSFE0MvDCVLP/6CzgIkCYPaFU
	 3LOl9gKn8lNz4iErQeTK6l6PS6lYQ/cdNHSF45n4INrRtEWKBoTvO0E5fEjgxpMSGOy49
	 MjBever0TQUjbTkOU8AS5S8k4+yf0WULDR18IdwNkSu3cTmZZtByYn8VH+7/87ynm2A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wZM6CRwABi3fstnzX44ArAuSrBU3GRfAEQ1WggcvHU4=;
	b=FtIT6+K1Yucx7RJTpxEek+MMISonHzfUnUueZ6Hvw8OoZWvyDPqXGGqVuB47ZKMsa267
	 W3fq/XMLFUenFQS+QsMCc416+LH+RrfzkbSkg4xMd02TRtPKTONcok+faklTof1qDgXnw
	 eNeqkMQYHGJTR1SkJJhkYIiqST+Kt8ub/HOQYj6F3rN3pYws6j88GKGR9epCbRpAGD2tC
	 AfechwNVPo5EQ0YSdTZvVCcKjsl30mVnKWZQO/2RFILrRHv41uFKuJ47ha6/bL9C2ssnE
	 1kj0z9POLlRiWjB21dEuFhxXYBIzHizzdSqWRJ9MHbYuydn9+4Ty3KODH8VyNcYQkYw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 926D91F0093C;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011834;
	bh=wZM6CRwABi3fstnzX44ArAuSrBU3GRfAEQ1WggcvHU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=liQDf2ND2DoP4lr/xVkpBNtdQuy5+FkGWG7EMA8QcUl7kgk8Iir/TP4YDIEMY90cj
	 RABnixlbaFE64trVoWBHQu+R0v11BPFyLeTYSO1/Hw47T0YxUEFiv90t8/YeemDwBn
	 hcqLx+xdRBqSnltoSl7w9gjoEded+CQTsIWZjTXbTmjATPut3jNKEv//sx4dJL89C4
	 uI4rr5vwkrGvHMKa8hZtvg156uifkHuBgpckMxs6iNSvVPionEt4Aw7pTlIjNtDOXp
	 0ggpLG+rYDAL6jJuoFNx/bRcqrPc+osrBGiXr8dj5laXUPH1GKh5rBrDibesO9X2y2
	 MU6HQye754PFA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5700A479D6;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:24 -0800
Subject: [PATCH RFC v3 50/88] KVM: selftests: Test guest_memfd conversions
 with sample memory provider backing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-50-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=5146;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pFmVA22FXGETZKWOVPROthnqtuyrzDD+ZHNTU/H+YNY=;
 b=11BVE+QRpNOg7Hd1AOFKxr49Ovvf9iM3u7cDh54/3reFREN7eARVv8IsPL4S1AeL3D5QnyytI
 dXlUBPCrGnZCsK0Evp6XvNHNHVCdLa2iZrWfJ9bMPZ/08Aj0X4KMUZn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: x6snomxdbqe5s9r78yuo195g6wrc96om
X-Rspamd-Queue-Id: 6288E120006
X-Rspam-User: 
X-HE-Tag: 1794011834-530269
X-HE-Meta: U2FsdGVkX19sRnDn9Spp9NvXN45h/0nJ3mJSlBUtM2eUlKw+s9YNZP+CMh8o/n8A3Otdvfw+dh0q+qNpzo/2MFu+bGsUl9cu5Lx1Ogbhn6FSSBKIe8JxVpgy/Pc4V7ffFNC2F6GBMydBMnk3fvsUIKK9mnWlRWU4Rp6sPT25PAUKKgaTAMv5njC9x9SFIKgQ/P3CV/iI0UmY0F3YmpeuEBqBSV1gkSdNqQkD5le/DaHpenHaNhQpz2gDzys7gz84GAy9+L0PGeOKOnllaE89tgCg492EDh6iiZKFD15EgPy27N4E18RQEe6vaLFYOuy4UtMpLqZ4Xh4WCxZCg0a81rxNkWI1sG3+Qjk/2AGs9mMnWICG8aWGzrVR7/PElNCA2wVAGJCidTzIDjiEJD8Dnycpn8eC8zeVLFBWLwOOX+NL6DFn1wnNNWqEpsWeN1eHVSHegDVYdH2kIwTHDZ/ncLQc0pjYlZCshQm6OiLN7nAkpxhREj+GIwDOXswZNYDv6ABRLpjeJmInDeBbHRJcI+aE9TrK/SO8CBa2Z24GgUUjJkeQeVmRwVGUcUk+zPZh9d9WR5A5zggSz2C1rnCSGxQrQlgCMFqqWECCOnKNo2Ck+78S+t58MRJD3NhwvIPX6KQcUROE724rx6/n3zirG5QigiF7KsL96NpPC/FmF54y7ZYYDBg2OdNXlGXed1ekPj7cqwOaN6YGkm1ZMv7Yxg3PRReOwV5/pi1PRneSSsLWeSLOWGS1XTvgKCsoCwOzcAt3kRW9Aeif3QpCDcQWpP1cz8aJVWp+13mByTYpvouVAtSPkE5viHnb2ySQ1E4MheHp+dz0vZfSa8gic8HwU6ZxmKwVbx+G9/iX9X5RH5+J+T66uYgYFHhjFkdc6fsdARXqPXLmYhaSslUSPA7h4KRzzgRj0fs4Jyr9JjnP1hI7sh4g0KURjYjYLRYpgCibRk3kSywInzQMhKRTojq
 ++VFazKW
 M+8UENzG3qUQI93BDTUyD3l0NjsKmF6H9enOqEOCEaU1V7miyOTAqeopjS9tSgNflp5YcEvBCUv225o+Xz4zg7HXEemBTMeCreZxysdVsV1lKjPt62qrlP1B+YxD+Icz/diCFQfc+ALrSwWcsYdvW2b4s7flzTiMwkt2obRyZaRXwt/A0dXWvzLajz6wm9zmZU3EHrZW9oMWsnwjIgSwKQ69+NZp17yfeTMKE4tNXuFsjjRrESiKM6/IDhMzmhe2fVPFkxVPG3HUT7AE1a+7J2jLQ8dkAonNA3NKvAsnVU01xixUcJ/qkEdhjP5DGAiw3z6eoFKcjcIfVoZOAHA07234Cma+mxEda2jeu5aSJBsuxtlh9x/Nl2Rnveq2g/brhwcuWV1urbAAQ3Of9RB2+FbglrtcUW2BkLotO5FEV1jeFgzDBfJTIw8p5QXkCBxf8GydUAUnYXyK6CxM2bZTMLhpUyTxkafg0B38SdfNmS5MYY97CnnKDDXGdr4JwngSDLIpYW7t8xNIPVzEGXT0sMasjPpvxdI1GKMC16oxctgRTLcmxI5PwyiSnK+MXyY0RfFZP0/6zHMMXtyk/uTdZMOPoqsZLfk61vzSWrJQomK5Jt9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add fixture variant for the sample memory provider.

If the sample memory provider cannot be opened because the module is not
loaded, the variant is skipped gracefully via TEST_REQUIRE().

Because PFN-backed memory cannot be pinned via GUP, expect pinning to fail
for the variant in the elevated_refcount test.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  9 ++++-
 .../kvm/x86/guest_memfd_conversions_test.c         | 44 +++++++++++++++++++++-
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index eca296539db79..1a1387f36a52c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1350,6 +1350,7 @@ static inline int pin_self_to_any_cpu(void)
 	return pin_task_to_any_cpu(pthread_self());
 }
 
+int __pin_pages(void *vaddr, uint64_t size);
 void pin_pages(void *vaddr, uint64_t size);
 void unpin_pages(void);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d42e201eba763..9793818f54d23 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -674,7 +674,7 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
 
 static int gup_test_fd = -1;
 
-void pin_pages(void *vaddr, uint64_t size)
+int __pin_pages(void *vaddr, uint64_t size)
 {
 	const struct pin_longterm_test args = {
 		.addr = (uint64_t)vaddr,
@@ -685,7 +685,12 @@ void pin_pages(void *vaddr, uint64_t size)
 	gup_test_fd = __open_path_or_exit("/sys/kernel/debug/gup_test", O_RDWR,
 					  "Is CONFIG_GUP_TEST enabled?");
 
-	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+	return ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args);
+}
+
+void pin_pages(void *vaddr, uint64_t size)
+{
+	TEST_ASSERT_EQ(__pin_pages(vaddr, size), 0);
 }
 
 void unpin_pages(void)
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 023df9cb9d4a6..d0cbb1353d7ee 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -16,11 +16,13 @@
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
+#include "../../../../samples/kvm/memory_provider.h"
 
 FIXTURE(gmem_conversions) {
 	struct kvm_vcpu *vcpu;
 	int gmem_fd;
 	int resource_fd;
+	bool expect_pin_failure;
 	/* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
 	char *mem;
 };
@@ -29,10 +31,14 @@ typedef FIXTURE_DATA(gmem_conversions) test_data_t;
 
 FIXTURE_VARIANT(gmem_conversions) {
 	int (*create_resource)(size_t size);
+	uint64_t extra_flags;
+	bool expect_pin_failure;
 };
 
 FIXTURE_VARIANT_ADD(gmem_conversions, native) {
 	.create_resource = NULL,
+	.extra_flags = 0,
+	.expect_pin_failure = false,
 };
 
 static int create_tmpfs_resource(size_t size)
@@ -42,6 +48,34 @@ static int create_tmpfs_resource(size_t size)
 
 FIXTURE_VARIANT_ADD(gmem_conversions, tmpfs) {
 	.create_resource = create_tmpfs_resource,
+	.extra_flags = 0,
+	.expect_pin_failure = false,
+};
+
+static int create_mp_resource(size_t size)
+{
+	struct mp_new_file nf = {
+		.size = size,
+	};
+	int dev_fd, fd;
+
+	dev_fd = open("/dev/memory_provider", O_RDWR);
+	if (dev_fd < 0) {
+		TEST_REQUIRE(errno != ENOENT && errno != ENODEV);
+		TEST_FAIL("Failed to open /dev/memory_provider: %d (%s)",
+			  errno, strerror(errno));
+	}
+
+	fd = ioctl(dev_fd, MP_NEW_FILE, &nf);
+	TEST_ASSERT(fd >= 0, "MP_NEW_FILE failed: %d (%s)", errno, strerror(errno));
+	close(dev_fd);
+	return fd;
+}
+
+FIXTURE_VARIANT_ADD(gmem_conversions, mp) {
+	.create_resource = create_mp_resource,
+	.extra_flags = GUEST_MEMFD_FLAG_PFN_MODE,
+	.expect_pin_failure = true,
 };
 
 FIXTURE_SETUP(gmem_conversions) { }
@@ -75,10 +109,12 @@ static void gmem_conversions_do_setup(test_data_t *t,
 
 	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
 
+	t->expect_pin_failure = variant->expect_pin_failure;
 	t->resource_fd = -1;
 
 	if (variant->create_resource) {
-		uint64_t flags = gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE;
+		uint64_t flags = gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE |
+				 variant->extra_flags;
 
 		t->resource_fd = variant->create_resource(size);
 		TEST_ASSERT(t->resource_fd >= 0, "Failed to create backing resource");
@@ -506,6 +542,12 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
 {
 	int i;
 
+	if (t->expect_pin_failure) {
+		TEST_ASSERT(__pin_pages(t->mem + test_page * page_size, page_size) < 0,
+			    "Pinning PFN-backed memory should fail");
+		return;
+	}
+
 	pin_pages(t->mem + test_page * page_size, page_size);
 
 	for (i = 0; i < nr_pages; i++)

-- 
2.56.0.455.g6c5a503b38-goog



