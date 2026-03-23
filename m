Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DF0F532C2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049686B00B7; Mon, 23 Mar 2026 19:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F150B6B00B9; Mon, 23 Mar 2026 19:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55C96B00BA; Mon, 23 Mar 2026 19:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFAB26B00B7
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71F2A8D1DD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:12 +0000 (UTC)
X-FDA: 84578996544.28.6660870
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id A37171C0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8OFSrJG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3zdPBaQgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3zdPBaQgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310350; a=rsa-sha256;
	cv=none;
	b=pcM5OcXut1m9+HnJs8tDXp8V13QWpAgD97fdXijD1B7zfj1ZjWkrq29Jh6Lqmn3rHcqOLA
	mxTfv7hYrVzC6v5KgY+JR0Ol/rmIZki4wSZ+wwevmyFWRU+sprRogUQo8kM5L7UTxNqUDv
	FhayNjzHNDY84hsIB3ANBzJ6e2VUOoY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=d8OFSrJG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3zdPBaQgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3zdPBaQgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUFryWFBPXxe6T+DTeCmqMtrNHQ62SSe5LgDU16cd+0=;
	b=P5r18aemZpr4CMiTEpNFP14Psjwn4ZTqIxep1PNS88UtgJ2G9qJphuC/89L2e/oMqcr5pX
	27HusbSP6uAx3i/4V+Y2avbkeKh1wQxRcZ+AYfhCYgHImEyw8FUG2c6Hzx0HNazAOLu1XL
	SlSHlJ44QUyZBWGUh+GC9b4PWU84TeU=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35a1e725a8fso24245723a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310349; x=1774915149; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JUFryWFBPXxe6T+DTeCmqMtrNHQ62SSe5LgDU16cd+0=;
        b=d8OFSrJGm/naDlcEH+/MGZobrsQ3a53/DNhqM/EWIYLt7sBWqHvGIUpoVpAPv+qX7L
         xAgScEIkaKNLhmLrzGcd7m56rjeYpjVHjmgbc1Qqj2YlxHn4WgOzEqyC2BGzAWBf5CFS
         Cbf4oYrVcHrT8m27/BDzcnDW8BwsAsGblS76bBtAh92lSHWcDT71GxyPKxCpFvfA3RNe
         +Wg/Zg9nKvs+jftKCyTtjV4rdY2p3brNFLPamwvwRJBUAlqXNGjZJ1/Jdi4+nCiQGGFn
         NccckGomNGPZZdTjdWMgDh6pGKO/mg0iQlRX7ou434v97QW28VRYVEw4fCGb3Y0HwpqV
         RHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310349; x=1774915149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JUFryWFBPXxe6T+DTeCmqMtrNHQ62SSe5LgDU16cd+0=;
        b=Sxtcs0piYKFdG8xdIYTvN/6BogPa1qzN4RFQ+KuU69aLVII+Ne3hCGWWHyiHt84kih
         zCb5GgPljpG5hu9t/mLxIrUg4NnRLfpWaULHSfn0ECKQYCEl9K+K0WHIDkWltWZhI5yF
         fqjIPUP9X8HV0BdAzadFMu156UG5X4ubOI8IG2qWywWEvJF++HUppSJbhI1RAUPlyHzu
         pk1sN1XKIDeGbuYXa6tLv+ovg0tIkCsCWiXC75mGr8kMejCEDqdJeblTOIGIps4fkWJb
         JPImxPY31ZnKXou/eq10YGTUWH9Hh5/BJP/5V6RLi1GZ30NdlYfirjm4Q2ridXnS0Nnu
         Z37A==
X-Forwarded-Encrypted: i=1; AJvYcCVIewJ9QNEbp2AJjO+57LrL0OZoMhrC5KcW80eph7eY2RNwxgGo3FKjWP4E24DZm2E2pAFHTwlXBg==@kvack.org
X-Gm-Message-State: AOJu0YzEMKMzasrQoPL9zG09nJNUBihbd017sdjtyM8wP5AxhqK6unSc
	OZYYgvakClKuYyuPQDth2OQ979mXgl0R0SnJqd6QjQ3kSkDomjVv6WFYqJiiY1Pyub6FEgjKjL/
	/7952UkjXdOfAjA==
X-Received: from pjub5.prod.google.com ([2002:a17:90a:cc05:b0:359:f1f1:7bcb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:1c08:b0:35b:e519:213b with SMTP id 98e67ed59e1d1-35be5192186mr4242377a91.30.1774310349283;
 Mon, 23 Mar 2026 16:59:09 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:10 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-19-dmatlack@google.com>
Subject: [PATCH v3 18/24] vfio: selftests: Add vfio_pci_liveupdate_uapi_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9adaqzhauef9uxfh3fy51xnfcfoqcw5k
X-Rspamd-Queue-Id: A37171C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774310350-423757
X-HE-Meta: U2FsdGVkX19eRZVgRaXe1jxQKmU6UbvV472is701vyo3qWUdQYfSrafTxXjGKEdO2IHlXxyHpIjcUGgWYcCRvlPp4LTBlfjeyhTTWad28tLcgsRQrNktcm2yzI6wbxfmSFGL7xdEIPPyR3lZf5Pak0oG9cm+ZQRdy5JT9Shfc465bLnrG999IpZ1tVXAkrjLSIjxD6E7Yq/kuOkyOF2Fp1owwj655BZ5UWKMfbd/0qNfUpIc2xGwQXVWx4YvMROFXVn3lgw+QdHDnhQDbceW7n9kbtVfrreso1/HtTd6CQ2YgmuucZetj9nQG7PyiIY9XpCf4RPVbPPVZbHw0zjjhTRO0vbmCI2QQll1DcKtWuG7O9Bi7bff3zzUMNF/OBTz4ymxvyiKHMOfpl+VJftdNwIrwweCXnvNKqMHWdLm+uVULk5vR4XWDf8x0t8mLntUfWUqki0hVf/GkmShvrmWBqF1dnSSbWlFXdaPqMGFD61+KIJGPHmNIWg70wp92MgOn55IH9vJsX92kvcjHcyk/PPURKOn6959Z//iYQcHFXzcM19rlSpcCfIfUJsPxhI+gXsTO3X0n54FVawn6PgERMYORSFiw3GhDy8t35cJMSJhn2y2NTiMIStIr6e2kWiIPhub2QlvTv/DOYi6RwCOWH9iEvSD7hcykU/nPS/aa3Fz2W9Zr0H1A5sJmeiCsa7pAULFVSxVi0LqFYbDheorG6iCids2Ne9Ul2d8MmoZoa0q0tKBHndVDODjbGuOVT6JGbfGF69ph8Tz+UVY+60w29ZwF/6h8GqjhTp/GFPy1LvtKfenWvDfBrcmeB+f0Eiq63sZgNFie0orN8nrhBrpkw6balOGunFTT7+C5SYZp/BNvly58kyNvUC20g/GXoN4Rdso7EoA2ru2dp0aHX/e6pCt7k6C3kUNhbl4UA/uS0IP8eiDlQ5tQHxeN/2j8Etea3zJVQrSiQI9ynSWU0f
 5GPVTIOL
 uVPHGN3aSpkHCz7IpNxhrx823WYjQfa0Opj+PjP1Wj9RnabV9rn+za0/8sIx+DHXdJ0VdW74QjYJqt2xKMc9yiKsAQd3n+4CQYFHShWLAdBpB7Yzzm5YwsrSjYsvjGNxyu1Dq7p0z+U5sD6K4cF5XrFCAUR1kHK76fwftn4e9kky/X2EMopEhMXiuEty+u0PAtZT0/F55B/khMmuUz25AiL99jyN80N4+W9f4stB20eMrjk/PEhtAmTwWFOeww3g6CMpg8h85A2qCRruqsHZjgp7IQS0iacRueocmrvDNrZYBYLlwJJZubHCOpAY1P5cbHwji0b4jGDM+UUFVrDjiAkd7t4gC6w4vzzOw3fyvKtAJWqFgWzmrA8hb++TIT8/yToax6AN5WSJRSCodAkUe7mMHf3hfovXeo7++/QCVF6ID14qxQwj+XOJGkcE706VEniDkVNGj11EQ3QzfflkFV6lqR8z8N+s355h1FNYwkJ5ap+IAi1Oi1Rv5k0DkUcTkNlwcaf4Xw7QacHC34cobX6ThaXG7LW2LFrKMRL8Jaa+c3jQuXvLWHnBfPjj2VnPc59V1icHi/nN5TMtCqHOEe/GUt7V14pRSVbXqf/z709nu8vN+Eqq/BockndCi7hJ/qXDfuiDtYmAzyKAGymmsVTAtVLSkk3ODAnPL7SeKEuxtH9uBo/MyHYYxeTIgbpZNRlgi
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
index 9d5e390a61b7..5b6e79593555 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += vfio_iommufd_setup_test
 TEST_GEN_PROGS += vfio_pci_device_test
 TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
+TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
new file mode 100644
index 000000000000..1d89b08ab0a4
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
2.53.0.983.g0bb29b3bc5-goog


