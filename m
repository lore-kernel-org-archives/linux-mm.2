Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AF1D73E8E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6799B6B00A3; Thu, 29 Jan 2026 16:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C826B00A4; Thu, 29 Jan 2026 16:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9926B00A5; Thu, 29 Jan 2026 16:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B07E6B00A3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 058588980E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:07 +0000 (UTC)
X-FDA: 84386284374.04.FDA713A
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34488140003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qKGsyUVz;
	spf=pass (imf26.hostedemail.com: domain of 3a9B7aQgKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3a9B7aQgKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUlLWwYhjyjIuuZGYT6Vav103VXsQgg/WHiCQN706aw=;
	b=VPBh9rZtH+Ikn3hpoZCoA9h6v5lg5jcUgFfzLAZ+brLhZCR0j4PEQqA3JFtW08x2fsHqkQ
	81odh+Dh437cCoimP4DjxUmGEicI+Bg+S+WcDadeabg23yShqefgXU5br6l5m/U3pFI8b8
	hVcgSje86C1503EjVUt0xjlfV3gJ2RI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qKGsyUVz;
	spf=pass (imf26.hostedemail.com: domain of 3a9B7aQgKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3a9B7aQgKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721965; a=rsa-sha256;
	cv=none;
	b=NmjZgp5eqTftwPSoRgTgLjvHed6mw4kIfGlH9gVpXxiSBuOjrvRk5YA6yirlIcucsMGtuo
	859xzH6RFgZ2/ogDa0LoMW1Az0eze5l1yho06f4w8DxJxoIGmlHYwNUCKWgBOPWXP18MhI
	KqXQtVLCeXzUQq5htotl2XQjqxZW77A=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso1383041a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721964; x=1770326764; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUlLWwYhjyjIuuZGYT6Vav103VXsQgg/WHiCQN706aw=;
        b=qKGsyUVzRGuyPfBQV3beSPOxh6o2jGofbBadtQfKHUKjh6yhzJvdML1jTpsJTKKY3o
         ojf5/tGgVL/N5SXo7cRTw4kNx9b2R6O0RNHQAHzki4Hi/Csb5sVLvB/123+S0vaOvEaJ
         Cgj++6wmHTE3iLaMSybCBSCOkmwBOXydpl33wTfWMo32pW/6lBN9Uz9yi+wtYUqLY46S
         E0dVR9oacCvSqUVUGqnYEEbTxikmX+mp5X6Uz/t3VllEAGMhC1Yok2hIjkpNLT5kQO4S
         ZbXyUcTMLLqGgxeUVB8AsAoo00cDwBDLXhEaKLGI0Xq9gfCmE44ZgCyWQ6VWQBabW9IY
         ZayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721964; x=1770326764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUlLWwYhjyjIuuZGYT6Vav103VXsQgg/WHiCQN706aw=;
        b=h6xRM/8yi4IypFIV3M0WH4umP01mNAyMM1e+m7PgORAN9QSecCiUzbvH584fjzLL4Z
         A/K6ZbjSq4ZFeV5zrkS0NDJgU6mnSALF9hIEFmYrbW9vcT+vf+RP/NvgJ9hpmzDrLo3X
         EYM0PXyBtg+iScBzXvl6ao4gJgf/LBJ82INLKPoxX4PDZ1gn5/h17LSqeCvsHsH2rkOW
         AhYM6tYvsfFFRt5V55Ko6pY16uq1nN6Zmp/0ZWdDaVXabX1ykZDGifCnhrRoGCENmfuy
         GVowiGupG0wgieq1Xb9fJ2nMEGB8wrH9c2Vi7uA38q9YzoJBfE4/PajNb8lAHM8pZwAc
         5nMg==
X-Forwarded-Encrypted: i=1; AJvYcCXEBeyhivRuO6vIaVvSQJspwHxfNeSfJ+XZh3OaMxQPG8mHRJAt6zcHjHrk/ZNhqFANQOkxl8Ditg==@kvack.org
X-Gm-Message-State: AOJu0YymkoazlHu8UG58i9xSNC+3LFwWvoErulIYXZlilpbMT+8UTXKh
	YcFyavxeOjeyy1TBCteaJKRZMfHQT0RWHk2Td2UfbNKcj36pYx2L6tb7s9H+tp9JlqOs5+BC8Bl
	6xpEd5EztrBb3Mg==
X-Received: from pjps20.prod.google.com ([2002:a17:90a:a114:b0:352:ca2d:ce63])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d64e:b0:341:2b78:61b8 with SMTP id 98e67ed59e1d1-3543b3d65f8mr671636a91.20.1769721963975;
 Thu, 29 Jan 2026 13:26:03 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:03 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-17-dmatlack@google.com>
Subject: [PATCH v2 16/22] vfio: selftests: Add vfio_pci_liveupdate_uapi_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w7u4i9x1j4p4m1pjwhfhaybnb6xteptp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34488140003
X-HE-Tag: 1769721964-797319
X-HE-Meta: U2FsdGVkX1+FVisrOTp07yrXd6v3/9EHYVONht8WuxBEZ2wkOORJ0WSRAhEi6Z60c896m4n/ekfhXwnt4D+OaGEEILHkXtqcPmmDqkz+Kr0E0NG9uBP7onCxeErY2KpZSiYBU/1slYYFuWxtWBrHnde0zHgsIMwZRlBRuEFa/sbS/CkLbqh6sP/K57c3k/q8M5SkHFTlxO4zqqmrMVnfprFnhbNHHsDng+FeiQmPH5dkLPgHP9+KL/khGpZxd2auV2U88zJNGyfI0CeyI131iTts2gcfFF4sz/64a/4Gu50gKSijwKyZeT7+Hkc+Cn1ONtYy/6XmiDdLoXvUMZW7KKaYy2EyXmsGv2NELsFSGgcH/wc8YfZjZOqSm2P18vWVGNLDlU/RPyS/Ii9sFmz3Bbs/lyPo+97FypDz+QiZ8W38YXlmVlyFTKVyOtaEkZzt7hqnSZajevUGWaurKnR3ntdNSvYJSrn4R6AGVHiput8GY5oosb11zHYzvwvyr/ZDLuy7JWDhjtUt/8OFah4AOpD9OBzGJ/Yk3zVjsbjqbBMScgC4oLz5ZcpyX4wxMi1p4pNEeMLgN5RUCu3niXlgvDHyz1CwnCeR4KpaQgRGvn0JtFkkTWQsNRgRyIZ9GPMfWq4AaFROwSwFxNR3WMmPxDXQnUXQv6TEUy10PUBdnZ5bQgmV6jr/RVXdtNoZSKhT3qdnugFUoX3YzWlFrF8gf1kUgsqmc+LxMFLndHyJ0DP+HvCtuin8QxKalyE6rJx+2n0m8cl/dIpgL9GUffxlF6DK4c/PQG+u0t3TDkfDDOSh432HoMS+TEAUTnL6OYubVQ0aiW6cUXgORJCTVzYb9FEZMhofwoC6Nj323th4NxyXYUdw+/bRnvT4Edl+iZS3z6nUCyGDjVezwYBZEXCNMp75WgEA4iS4Dj0aQtCoDhVdNrwcIdbH4jRbBf4f3rhgeTmPo/SHfSJomUEd61E
 vEzlxT7O
 gtXeakGbllp5ywXCvTOZV4kP6NzO0N/Pb+lIuZUu/ExZ4wIsMzqBhNG8fkxsoOCxzRZbMtD4oA5JssgI+ELfHZ0TxX7/72QJENNooV9z2TnT9Dsq6R+b2iKhGKviibjojxdXpygWV+puuJeCtA78Vt08g6pw/xe/vkiRyqwynjwFLWN7zY55Bsf2RKRlZ/BGQ2aulSDatXAQydRahcU/xhmDlvM+QYEwTVJARlurQHNLfml1OJxhRJ+JUryxX3b2OsQiGWPybqd/gXK/Fb76YBkNCHQKvV8e2qufHfIJXZSROAb9+2uzMHgyGKYgDt2AZlYyPTjHwuBdKtdGFEn2VWrMbJnrWlGT/ufBVT3wVwrZPFQ5gah7mXq1KDdFXStwxH8UKVKbTycoptt2pBy+1k6fGS2oEKGC22IwB2DXMvHiAIVeCgFN1T444SB+vUtbv+UEeBTWPlm4zrTICaRCgEPImGw67iYsF51vmCuxWweI8/dNxLi1kJmxEmGmjtIKgaLa5u2zkQnKZC2/HF8MOP1Q1/Cn19ZL1o8P1p1nnpIzamS3fRsiHN16cZRcypGAaaAbPTJf/c+pmcJyOLLa6HnzBtCTVvb9biclCqsWRnhE7HIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest to exercise preserving a various VFIO files through
/dev/liveupdate. Ensure that VFIO cdev device files can be preserved and
everything else (group-based device files, group files, and container
files) all fail.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |  1 +
 .../vfio/vfio_pci_liveupdate_uapi_test.c      | 93 +++++++++++++++++++
 2 files changed, 94 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index f9c040094d4a..666310872217 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -4,6 +4,7 @@ TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
new file mode 100644
index 000000000000..3b4276b2532c
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
@@ -0,0 +1,93 @@
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
+	ASSERT_GE(self->luo_fd, 0);
+
+	self->session_fd = luo_create_session(self->luo_fd, "session");
+	ASSERT_GE(self->session_fd, 0);
+
+	self->iommu = iommu_init(variant->iommu_mode);
+	self->device = vfio_pci_device_init(device_bdf, self->iommu);
+}
+
+FIXTURE_TEARDOWN(vfio_pci_liveupdate_uapi_test)
+{
+	vfio_pci_device_cleanup(self->device);
+	iommu_cleanup(self->iommu);
+	close(self->session_fd);
+	close(self->luo_fd);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
+{
+	int ret;
+
+	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
+
+	/* Preservation should only be supported for VFIO cdev files. */
+	ASSERT_EQ(ret, self->iommu->iommufd ? 0 : -ENOENT);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
+{
+	int ret;
+
+	if (self->iommu->iommufd)
+		return;
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
+		return;
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
+	if (fd < 0) {
+		printf("open(%s) failed: %s, skipping\n", LUO_DEVICE, strerror(errno));
+		return KSFT_SKIP;
+	}
+	close(fd);
+
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+	return test_harness_run(argc, argv);
+}
-- 
2.53.0.rc1.225.gd81095ad13-goog


