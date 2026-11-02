Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEF5608B7CE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DyLDIKSO
Received: by kanga.kvack.org (Postfix)
	id 445D96B065A; Mon,  2 Nov 2026 10:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFE56B065B; Mon,  2 Nov 2026 10:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297606B065C; Mon,  2 Nov 2026 10:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0240F6B065A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94E3BA0175
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:28 +0000 (UTC)
X-FDA: 85390583376.20.CFE817A
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0988E2000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DyLDIKSO;
	spf=pass (imf31.hostedemail.com: domain of 3Na7oagcKCJIH4B49E32AA270.yA8749GJ-886Hwy6.AD2@flex--vipinsh.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Na7oagcKCJIH4B49E32AA270.yA8749GJ-886Hwy6.AD2@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633846;
	b=ZViJ9FYnWCYltLapnPrV2D7tzb5d/8cMqx3oLlh/smTjG5+A3cLfgJjG3nfQSHEDDerFhp
	Q/MBvHLDXliqdSYaBzQFwINFDrnzpDDFDD3KCF3Zggwwjydgi0krxMrKkC9jT2rTYs0rqE
	FGMVQ2UGnCg0sLW6xgpKehICQtI9mDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5Sj6s4WCpHUP3cSZIKUa0LCg/XSbNt4xz/AARSS1Lk=;
	b=N9sLu9C+5mrdXjM5AtYKnI2Ikr3rTObzZ4+QxP/FA5zIt3ATBsKsAzUZ2932wsAB70HoVI
	Y4EPPhxyNPr2DqzWn6WVf3RU2y+EphRnpeq0OHxrkZzGK98ZO2ZvoseAZxr78ElbS2rc5h
	0lBVF5luCJZTgJqSs6xjiZGrZEjnHy4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=DyLDIKSO;
	spf=pass (imf31.hostedemail.com: domain of 3Na7oagcKCJIH4B49E32AA270.yA8749GJ-886Hwy6.AD2@flex--vipinsh.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3Na7oagcKCJIH4B49E32AA270.yA8749GJ-886Hwy6.AD2@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso3322350a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633846; x=1794238646; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P5Sj6s4WCpHUP3cSZIKUa0LCg/XSbNt4xz/AARSS1Lk=;
        b=DyLDIKSONx0DdIRGJJ7QXm/vGMTk9woCRS2+nVzZDCMi3fNqmMP1pGx6qO/HEngNpp
         30sne51rxM8sQhrZjKiDVwLsy0fnflndI7Y0+frbs32TARZE/g91LZzExkOaepQT5CUh
         hDwkCj39EWUKTEeVe1zVmp5ChJZtvt/WAAr6OWD3POCPRCNOPtMkuA7MBQOxHZHpiRd5
         r0ZdAwt554BdUWfud2a/f7+XUo9IgY7EHDE8JzqQZj+mZ+bYnZVAr5Wygmp76/0k/QkA
         oJkKrILUvjDaN3nw56ZT5UG6RTnEcse0TxOoMhjH/HolpbRYoE7lDjfyQY+XVNivrUEL
         gIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633846; x=1794238646;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P5Sj6s4WCpHUP3cSZIKUa0LCg/XSbNt4xz/AARSS1Lk=;
        b=aVnixN7ZkJIWTAx1LGFADA722VUjHXdHFxyHGM6uSFiLnCZKlmChbr4vI5WOP8/WRQ
         gkBHes/nokmF6gEnMMBw9EQLJKfoT/V7AaoKB6cYVq8WU44odUKXB68HUPLRRHNcbKiS
         Hx4DxDuDsdWgXTMJZ66E3Y6Guox+R0j8whKkWJ585f/8pUnZHFeHmG7QtTLyU0i6bZWx
         lTs4Ih1yMdn2TBYGcRXyrofhHnc7Y4Emug5MhvYAbA13vBmkM3b5UY7axKGBANLndgoU
         70ex4LmvboNzEfG6tdbSGYH6wNMLPgW0ReY8bI9M7zzdX+MAdjYtRHSdQMJGgz+fZi9c
         EIKA==
X-Forwarded-Encrypted: i=1; AKwUvByAPYi/6vE7dGq3VOV1u7Fac24JKQCXqR6Bm+zGv8vF/W4T9jsYxXO//X49LV5P+53OmidKl2v+IA==@kvack.org
X-Gm-Message-State: AFq9FYLnV46jCGhs6bPDIdaHF3bqysB/4dnLBzWI5kInyZIErL4kpygN
	aEHLeCmreAMB9HcTD6WC7AvgcXAQbIuR8v7EPPZww/H5ywQ58KDI+Haw/vLX8jcUorEOn2R+Msx
	Ov7gZ19xDww==
X-Received: from pgy32.prod.google.com ([2002:a63:1860:0:b0:cd6:1e1f:43b])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b58b:b0:3e1:9220:9d10
 with SMTP id adf61e73a8af0-3e928986bcemr8116448637.35.1793633845567; Mon, 02
 Nov 2026 07:37:25 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:53 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-25-vipinsh@google.com>
Subject: [PATCH v6 24/27] vfio: selftests: Test preserving noiommu devices in vfio_pci_liveupdate_uapi_test
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
X-Stat-Signature: 9hj9p85ss6fcnnh4km41dz39u3wiwwzg
X-Rspamd-Queue-Id: 0988E2000D
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633847-589046
X-HE-Meta: U2FsdGVkX181iwo/5ogC7wd11/IuumlJDNTZVu2lcHtYw/NTWCITLkTMRbnpNqwIs8tCtWJi+tZkIpPdniH1aTYOCVTQdMfLIYzGTphyydtdTqCsaqE979dMRQngao9H89wEzDDTEGReN3pT99WvFnk7UInRJsHqtqERMDLodT+aKgYkjQ5EGA7vVDN5/nnrztJ8+Jlf7mS6DOUvXsZQzkvDvPtDnmxrdWHhVlAB7uKozpku3yUgCkOfxw7p1OOGImB9+nbuIHCSPe8UFf0RNQFSaKIRpLx9GmsOux4DD36GE0uy5QtWi6BxmVQfAA2brHQ6x2i23qxyJ0Pmzup0d++O6+g7o5nk/zYSS70+WCEXA6cBMd1hLorFtWB7reD1BIN4d9rltvuY7Tz4M8w32Oj/V3AkM1pdMwBOyy23I5S9yuyCuTdUZQZqaic8fmrWgT9jFwVbvzn0J64qsJaK2jEyiIugQR+3lZWtH7QJUJGf6FYJW/6XJEU67HA/DwRqDQ9+eu3GQ8k+PgE3mgDGwgO2fwYxm2G64OHxBhYsuMK84q08Di1D+cGOnje9C0SUhjJEsJ3bhETEM0K6uHxOf1lUiViq3231X0sYNEFJPfZHeVu3cpkbC6qPoG1SSreBDNR88dtWMOxmuz4GTbOjF5qwdR39O9jbCLz1HEMYz/CRtRVgnUJtlL7MaftXZbArN5jLhGk8iMufL/2jgCv/ixUZjqJK/p4IRs6CwZh1ipI6IoT9pzQvMu86YVaG5e9M1tKtE8eRo5G44x7IWe213Oi+1gj27jLpVPdFmXHq2TrFwIXn7nnvzTkdCw403o2eaVCP6G0aeGEjV+MtDggSABnudShrGIBGh2MIj1egco5ozzTR5fQwPEF36wFDhwcRonmK3uxdUn41maGLQmYfX04V253YyFUFyuSDM81sQB6LgoCGnkslNkxEP70ZJip1WCXu0nQpFr101oggEvP
 6biMlY+I
 HH5Ef+rf0gzEkOo5mqkZ54DC6Gm1hVA2f5F+ZzE8A8UHSzWaTgtN95EM/Beud7rnkryewi3Isq/9Tl35ayi+/5VthOp6MEz56Tvx/DCFgh/LpdnrH/vJ3G7hwIZ3MLEKu+eaI5455veCPgSx2cAG5ozTiDyvEaNE5h3EiPifTaC7naerKbxdvNlxEeI4olJE5oYcp0USveqa5gA6JYouoQAAKlOgIA8ntoownisE3WqB8rJDf/oB63iZDsjyBIj5GX7bxUG5J2IZJXkDnZy4IKGxuEAPlxZjwXc3D35By8HcC1HwIwEi1yPZbhFEmuYwqhflawbFYt+oMdQp5chsif/yP94JvZBwi2daxrImCn7MlHApcFPe8I1j5F7NfNs61CT8LRxU0qkFnzLRZiMMRZxzmd6LRFbbJzdJIsB8ZMtLAey3QJxpp6qiF19m8oThap0rihCNcn74uKupAMaD7mR0M71apUKeF8dLi25p/8nANivRKG9z2O/ssAVbDMGsqb4gWW+o0wRc3ya2ATlge4FpJegZi2aLMpfZkj7Wg44dVeVNyoS+dFpVxdnEPqJV628bBZBk0W9b2oJCjfCkXdOV2IzM0tqS/Ws9q/q9st9/CjdgiAGYs7yPCoEcdLYlWNMYDPQQkQT1cbLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the iommufd_noiommu fixture variant to vfio_pci_liveupdate_uapi_test
and detect at startup whether the target device is bound to vfio-pci in
noiommu mode so that variants not matching the device cleanly skip, in
addition to skipping iommufd variants when probing
luo_session_preserve_fd() in FIXTURE_SETUP reports -ENOENT (e.g. on an
SR-IOV VF or when CONFIG_VFIO_PCI_LIVEUPDATE=n).

When the device is in noiommu mode, verify that preserving its bound
VFIO cdev FD succeeds, and add tests verifying that:
- preserving an unbound second cdev FD fails with -ENOENT without
  affecting the bound FD (preserve_unbound_fd_fails),
- preserving a cdev FD that was never bound fails with -ENOENT
  (preserve_never_bound_fails), and
- closing the Live Update session unpreserves the device so that it can
  be preserved again in a new session (preserve_after_unpreserve).

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/vfio_pci_liveupdate_uapi_test.c      | 103 +++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
index da25ea4e2b1e..46e97caf1f54 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c
@@ -1,10 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <fcntl.h>
+#include <linux/pci_regs.h>
 #include <libliveupdate.h>
 #include <libvfio.h>
 #include <kselftest_harness.h>
 
 static const char *device_bdf;
+static bool device_is_noiommu;
 
 FIXTURE(vfio_pci_liveupdate_uapi_test) {
 	int luo_fd;
@@ -45,10 +48,19 @@ FIXTURE_VARIANT_ADD(vfio_pci_liveupdate_uapi_test, _iommu_mode) {	\
 }
 
 FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
+FIXTURE_VARIANT_ADD_IOMMU_MODE(iommufd_noiommu);
 #undef FIXTURE_VARIANT_ADD_IOMMU_MODE
 
 FIXTURE_SETUP(vfio_pci_liveupdate_uapi_test)
 {
+	bool variant_is_noiommu;
+
+	variant_is_noiommu = !strcmp(variant->iommu_mode, MODE_IOMMUFD_NOIOMMU);
+	if (variant_is_noiommu != device_is_noiommu)
+		SKIP(return, "%s does not apply to a %s device",
+		     variant->iommu_mode,
+		     device_is_noiommu ? "noiommu" : "non-noiommu");
+
 	self->luo_fd = luo_open_device();
 	ASSERT_GT(self->luo_fd, 0);
 
@@ -77,6 +89,7 @@ FIXTURE_TEARDOWN(vfio_pci_liveupdate_uapi_test)
 
 TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
 {
+	int expected;
 	int ret;
 
 	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
@@ -85,7 +98,84 @@ TEST_F(vfio_pci_liveupdate_uapi_test, preserve_device)
 	 * Only VFIO cdev files of devices in noiommu mode can be preserved;
 	 * device files obtained through a VFIO group never can.
 	 */
-	ASSERT_EQ(ret, self->iommu->iommufd ? -EOPNOTSUPP : -ENOENT);
+	if (device_is_noiommu)
+		expected = 0;
+	else
+		expected = self->iommu->iommufd ? -EOPNOTSUPP : -ENOENT;
+
+	ASSERT_EQ(ret, expected);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_unbound_fd_fails)
+{
+	const char *cdev_path;
+	int unbound_fd;
+	int ret;
+
+	if (!self->iommu->iommufd)
+		SKIP(return, "Only iommufd modes use VFIO cdev files");
+
+	cdev_path = __vfio_pci_get_cdev_path(device_bdf, device_is_noiommu);
+	ASSERT_NE(cdev_path, NULL);
+
+	unbound_fd = open(cdev_path, O_RDWR);
+	ASSERT_GE(unbound_fd, 0);
+	free((void *)cdev_path);
+
+	/*
+	 * A second cdev FD that has not been bound via VFIO_DEVICE_BIND_IOMMUFD
+	 * must be rejected even while another FD for the same device is bound.
+	 */
+	ret = luo_session_preserve_fd(self->session_fd, unbound_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+	ASSERT_EQ(close(unbound_fd), 0);
+
+	/* Verify the failed attempt had no side effects on the bound FD. */
+	ret = luo_session_preserve_fd(self->session_fd, self->device->fd, 0);
+	ASSERT_EQ(ret, device_is_noiommu ? 0 : -EOPNOTSUPP);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_never_bound_fails)
+{
+	const char *cdev_path;
+	int unbound_fd;
+	int ret;
+
+	if (!self->iommu->iommufd)
+		SKIP(return, "Only iommufd modes use VFIO cdev files");
+
+	vfio_pci_device_cleanup(self->device);
+	self->device = NULL;
+
+	cdev_path = __vfio_pci_get_cdev_path(device_bdf, device_is_noiommu);
+	ASSERT_NE(cdev_path, NULL);
+
+	unbound_fd = open(cdev_path, O_RDWR);
+	ASSERT_GE(unbound_fd, 0);
+	free((void *)cdev_path);
+
+	ret = luo_session_preserve_fd(self->session_fd, unbound_fd, 0);
+	ASSERT_EQ(ret, -ENOENT);
+	ASSERT_EQ(close(unbound_fd), 0);
+}
+
+TEST_F(vfio_pci_liveupdate_uapi_test, preserve_after_unpreserve)
+{
+	u16 vendor_id;
+
+	if (!device_is_noiommu)
+		SKIP(return, "Only noiommu devices can be preserved");
+
+	ASSERT_EQ(luo_session_preserve_fd(self->session_fd, self->device->fd, 0), 0);
+
+	ASSERT_EQ(close(self->session_fd), 0);
+	self->session_fd = luo_create_session(self->luo_fd, "session2");
+	ASSERT_GT(self->session_fd, 0);
+
+	ASSERT_EQ(luo_session_preserve_fd(self->session_fd, self->device->fd, 0), 0);
+
+	vendor_id = vfio_pci_config_readw(self->device, PCI_VENDOR_ID);
+	ASSERT_NE(vendor_id, 0xffff);
 }
 
 TEST_F(vfio_pci_liveupdate_uapi_test, preserve_group_fails)
@@ -112,6 +202,7 @@ TEST_F(vfio_pci_liveupdate_uapi_test, preserve_container_fails)
 
 int main(int argc, char *argv[])
 {
+	const char *cdev_path;
 	int fd;
 
 	fd = luo_open_device();
@@ -122,5 +213,15 @@ int main(int argc, char *argv[])
 	close(fd);
 
 	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	cdev_path = __vfio_pci_get_cdev_path(device_bdf, true);
+	if (cdev_path) {
+		device_is_noiommu = true;
+	} else {
+		cdev_path = vfio_pci_get_cdev_path(device_bdf);
+		device_is_noiommu = false;
+	}
+	free((void *)cdev_path);
+
 	return test_harness_run(argc, argv);
 }
-- 
2.56.0.317.g454f8302e1-goog


