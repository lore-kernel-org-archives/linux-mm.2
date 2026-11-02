Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EA5606B1D7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H3sjKGoX
Received: by kanga.kvack.org (Postfix)
	id 1381F6B0651; Mon,  2 Nov 2026 10:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0425F6B0652; Mon,  2 Nov 2026 10:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F296B0653; Mon,  2 Nov 2026 10:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6D786B0651
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C2C380175
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:21 +0000 (UTC)
X-FDA: 85390583082.19.837E633
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8AD9A180006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H3sjKGoX;
	spf=pass (imf06.hostedemail.com: domain of 3Lq7oagcKCIsAx4x27wv33v0t.r310x29C-11zAprz.36v@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Lq7oagcKCIsAx4x27wv33v0t.r310x29C-11zAprz.36v@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs0C+G7zjdZllGuTbQSqQheVXxWPk9ZHdH8YJo8R+C0=;
	b=7dmzP3DfO7zCFLr9YBMa7T8iQHjMgjfPYyZBNyX18af4peyY02rFt0WdLGaGrt8X1xbLRN
	X8RFg0pGG8G0ro6kJ2GnwcF7czdIyaK1R+SpoDV5UZUSeeSCCg7mtwzlOa/TtFA1Tnpail
	bdWyjojY2m1sNFIZuUAteNXyFlghfGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633839;
	b=dVXUxOz6IQdZbjv6I1iK2YopSckb7Dywsa1JDvDruNZjpQpTVwR+Jqckt7Agtrb92DDCsM
	s/LppaX7xOBxQ/0beI1ni3ruaUsozQLctUG4pgq+b9Ik/336PI/1ZBRd1b/sjBrAHGVeNd
	/wluxC40/XjzD7keO1HyoD54Woilb/Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=H3sjKGoX;
	spf=pass (imf06.hostedemail.com: domain of 3Lq7oagcKCIsAx4x27wv33v0t.r310x29C-11zAprz.36v@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Lq7oagcKCIsAx4x27wv33v0t.r310x29C-11zAprz.36v@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e8e16d22d8so48345225ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633838; x=1794238638; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xs0C+G7zjdZllGuTbQSqQheVXxWPk9ZHdH8YJo8R+C0=;
        b=H3sjKGoXZ0W9gAZpjQpkOlJtyLyrnhDJrRsZDVKXxxeohH+5KFuYsRWS/QSiIKQi4x
         KUxMTGvBFT7HZvUJpO5PO6DnTo/o+3RiO4fJIU8E1waMLHXJ7eobSqNUm65iS+MIWDRe
         PjtAETZu2NZV/AssliW9kBSw6LMwu71HqrxlYGDLzzpIvWolUSKcH7KWRB+Sott1B9d/
         iie1nPk6FaKhQx2ame3ijwls9ngjBRfAd8JAF/IvA4bT8R4f7waYKvaCElnGYC79ABW1
         2TFRMwREI5rdazBrXSGx/I0nZMWqEDKVl06lL6AKvzjug2eaXSJ7JcGTBNGviN4TFAPU
         V2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633838; x=1794238638;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xs0C+G7zjdZllGuTbQSqQheVXxWPk9ZHdH8YJo8R+C0=;
        b=LzKo1kgi/PPTqQqPIQtSXdT1AvxNxzaJQaJYDaZq8WojMChnGNAd+u5oOGAcHLOz5J
         pcalx5uUXvCOnBzXEnEbxHZ8Uq5R9iXi5Ll/RpzETrlim68AqV82QQyf4QC7uJQCWkG5
         jhy4BeVmtATJPDkitwm0o0ZCp2LBIcu/bDngqy48vDbkF/OlcAz3SmOJs4BEBpbz8CfW
         LHvMPnrbAfbEHr8xc1XOk1NLrxkUoKeI6pvt9EZhLp8Sja6fH4zhRJL8Wxb/oSdDUBsa
         UjsWlVnVaM0Kfjvoqw3b2aIjwPqTndDjyfc8S5YPveRHgaBYDQFG6Ipp5TR5WU+SQuN3
         nGKQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJY4xxX+4CCQGDuVMtSGM7RIV1AKtdRGQzooobFN1i25jcHOEcANVmvGkErc5n3hCRiwIyj/Lx3w==@kvack.org
X-Gm-Message-State: APuU4Z876fCgQvWJIkCeVKfCYB+eiaYStq8nzxH77umePse3J9EBdppT
	4CQphcu3JOx3ZqcBzDsRQNQIhiyrDPmc7+4zTb4cICT+624dusjucDmzk9hZjiG7xJG06/D/Dm7
	V0nDEjLUshA==
X-Received: from plko2.prod.google.com ([2002:a17:902:6b02:b0:2e8:bfd5:b889])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f542:b0:2e9:9263:a5f
 with SMTP id d9443c01a7336-2eb36493707mr97418395ad.17.1793633838083; Mon, 02
 Nov 2026 07:37:18 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:46 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-18-vipinsh@google.com>
Subject: [PATCH v6 17/27] vfio: selftests: Add vfio_pci_liveupdate_uapi_test
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AD9A180006
X-Stat-Signature: yabqbn3grn4eqdzc4zhiecuysu5pn19a
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633839-551120
X-HE-Meta: U2FsdGVkX1+N7a2i4zWN++zXSxfg0rxQh6+Y9zDWoMDg/gkS5vTi7RVLwxc88gIcCxroHViMGSCBGsadEmgyoqACwxdCbWXA0EhsRM7y3w3il7NG4OjDkEMkr0BJbIsoc8CvYarSO6SIrZcHYgjnf/qBAlh8dCaRfn2sH3qTqmuJ8cmG08BYij+80SnA+Y+Z5cnG4MJ3wQmcvwDNIQPtOWKo8kvEWwH3Xcp07X3VErdevCZ0Qaoxy5srusl/OdE65iS9CjOC9g5TFCTtAugXQzzeVA7K44e0F8PkflafY6YoD6I7fJF9egdNHhiwqa/37mXy2vZMtLngKzWM2JSP0W7Z5GnCOjJlSVBj115D5DXo5Fgv9AYJTjcpB5y6wvInpWahpRoJ6Q+cKJkGt4uw1yut6k5/M57TgzvyykYR68IsN75pKroUN98wCM0l7p2xXxeEQtGENe9Dfz3oyMKzbSYURDeUDPlKiS9iXYxyEqwvZEjUaVlETSEil+5OrLnzm3qZcS+H0knO0C3SoDpphu23vj+uTdEOykyp1Qp8ceMWby2evpZQ3sb7Ha7/jU6MSa8JDC1ncGDsrDfgGMjtXhC4pVkyQ3OGfWxX0kASPKYtIyhsajuVfZoGbDmA6q2cmaOusGPOs/523z1LAG0DuingOMbfTsvI84sksx3WcEeEX7F0/eFMZOmT5EPqIjlo4zZ/KSOorrvuJy+pdeoCFjpbv63+vYFkPRqvNzctwcZGzXZrs0VxTDcoskYAbbmeYuoZmb5XhtnD9zZ8NRnmH0uNgmQov7oPCIApH0mkkkosfS/+sDTAwj6wYj0MAWhA7OmqpghgA9Gto3LqK9mwtcQX/WjVZ1EK8M8kUJ1tCM5zIfFjRWqyeW0tqJHBq8YrGa1rXFC864HON+eVKDgcxwX6YwpRHsTdpXni5O3hzNsp2aCTYTGkYUQfyAhQ0rZ/dKxkn6WzE1MaeBi9FiV
 Ien53y9G
 c3xxwW5ipNZX10RmCuQp4VkSOdjPLpCQIUf6JNb4zBq9iBlqlxQabTVCqZZ+XvZro89SJaRbiw+jiDd8wl/7VFaPyyxSDBXn2yUflILsAESc1sqdJ/GmhGSEZ++HaHWeVDNCy9E6v2d579bkL/CeaLJHQGsoCCxC6Fm2Fee7VXcozrxrncZZ6OxDK2aSY9p6ozYzLf1Qi22Mp33J+QOJ4W8ukfnsLzn+YebMAEy9a5fTwttwhwVnsSwaXPfhaHM9/0CdJA4zKh1j6t06CsePckj1IT3gUBBllXEazZ4gna5kDvfx9HJqAdi4VO3BW5FCY+sefqQYfGqiRa9xu+p0KESqJGoS10Bsw6N1QYzTGr2NlMssEmfiQLifxwVhdy7Xl7GIkTwd8Chs9V8z7ybDapVVv0vaLHU9p4twx01LYpSxePrb+tU1B6AZWnLebnvJ4UPd6YDl5yKSzvAHHaXUbVOfjf6axV4l8ZQ7y6vLwNjLMaOlyeO11+Ksr4jx/VlGTaPppmQlaewSt2UfjVglsHgR/L6jf/VveqL0y0/wazU/2KrdfFrmx+mJIz6lY5A/SSpxfD/0EaxMSwmOVS8J2Y00jpqgPxw8miBcyOA+WilitZR4FAaEYki1RicoJN8gaK1zK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: David Matlack <dmatlack@google.com>

Add a selftest to exercise preserving various VFIO files through
/dev/liveupdate. Only the VFIO cdev files of devices in noiommu mode can
be preserved. Ensure that preserving the cdev file of a device that is
not in noiommu mode fails, and that everything else (group-based device
files, group files, and container files) fails too.

In FIXTURE_SETUP, probe luo_session_preserve_fd() on the bound cdev FD
in a temporary session for iommufd variants and skip if LUO returns
-ENOENT, so the test skips cleanly when CONFIG_VFIO_PCI_LIVEUPDATE=n or
when the target device does not support VFIO PCI Live Update (e.g. an
SR-IOV VF).

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   1 +
 .../vfio/vfio_pci_liveupdate_uapi_test.c      | 126 ++++++++++++++++++
 2 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 55e1e1843090..c2764fcef31d 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -13,6 +13,7 @@ TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
 TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
+TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
new file mode 100644
index 000000000000..da25ea4e2b1e
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <libliveupdate.h>
+#include <libvfio.h>
+#include <kselftest_harness.h>
+
+static const char *device_bdf;
+
+FIXTURE(vfio_pci_liveupdate_uapi_test) {
+	int luo_fd;
+	int session_fd;
+	struct iommu *iommu;
+	struct vfio_pci_device *device;
+};
+
+/*
+ * LUO fails with -ENOENT if no file handler accepts a file. For the bound VFIO
+ * cdev file of a device, that means that the kernel lacks VFIO PCI Live Update
+ * support (CONFIG_VFIO_PCI_LIVEUPDATE=n) or that vfio-pci does not support
+ * preserving the device (e.g. an SR-IOV VF).
+ */
+static bool device_preserve_supported(int luo_fd, int device_fd)
+{
+	int session_fd;
+	int ret;
+
+	session_fd = luo_create_session(luo_fd, "probe");
+	VFIO_ASSERT_GE(session_fd, 0);
+
+	ret = luo_session_preserve_fd(session_fd, device_fd, 0);
+
+	/* Closing the session unpreserves the device. */
+	VFIO_ASSERT_EQ(close(session_fd), 0);
+
+	return ret != -ENOENT;
+}
+
+FIXTURE_VARIANT(vfio_pci_liveupdate_uapi_test) {
+	const char *iommu_mode;
+};
+
+#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode)			\
+FIXTURE_VARIANT_ADD(vfio_pci_liveupdate_uapi_test, _iommu_mode) {	\
+	.iommu_mode = #_iommu_mode,					\
+}
+
+FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
+#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
+
+FIXTURE_SETUP(vfio_pci_liveupdate_uapi_test)
+{
+	self->luo_fd = luo_open_device();
+	ASSERT_GT(self->luo_fd, 0);
+
+	self->session_fd = luo_create_session(self->luo_fd, "session");
+	ASSERT_GT(self->session_fd, 0);
+
+	self->iommu = iommu_init(variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, self->iommu);
+
+	if (self->iommu->iommufd &&
+	    !device_preserve_supported(self->luo_fd, self->device->fd))
+		SKIP(return, "Live Update of %s is not supported", device_bdf);
+}
+
+FIXTURE_TEARDOWN(vfio_pci_liveupdate_uapi_test)
+{
+	if (self->device)
+		vfio_pci_device_cleanup(self->device);
+	if (self->iommu)
+		iommu_cleanup(self->iommu);
+	if (self->session_fd > 0)
+		close(self->session_fd);
+	if (self->luo_fd > 0)
+		close(self->luo_fd);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
+{
+	int ret;
+
+	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
+
+	/*
+	 * Only VFIO cdev files of devices in noiommu mode can be preserved;
+	 * device files obtained through a VFIO group never can.
+	 */
+	ASSERT_EQ(ret, self->iommu->iommufd ? -EOPNOTSUPP : -ENOENT);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
+{
+	int ret;
+
+	if (self->iommu->iommufd)
+		SKIP(return, "iommufd-mode does not have group files");
+
+	ret = luo_session_preserve_fd(self->session_fd, self->device->group_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_container_fails)
+{
+	int ret;
+
+	if (self->iommu->iommufd)
+		SKIP(return, "iommufd-mode does not have container files");
+
+	ret = luo_session_preserve_fd(self->session_fd, self->iommu->container_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+
+	fd = luo_open_device();
+	if (fd < 0)
+		ksft_exit_skip("open(%s) failed: %s, skipping\n",
+			       LUO_DEVICE, strerror(errno));
+
+	close(fd);
+
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.56.0.317.g454f8302e1-goog


